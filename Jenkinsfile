pipeline {
  agent { label 'infra' }   

  environment {
    TF_IN_AUTOMATION = 'true'
    APP_TF_DIR       = 'app'   
   }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        sh """
          cd ${APP_TF_DIR}
          terraform init -input=false
        """
      }
    }

    stage('Terraform Format') {
      steps {
        sh """
          cd ${APP_TF_DIR}
          echo "Running terraform fmt..."
          terraform fmt -recursive
        """
      }
    }

    stage('Terraform Validate') {
      steps {
        sh """
          cd ${APP_TF_DIR}
          echo "Running terraform validate..."
          terraform validate
        """
      }
    }

    stage('Terraform Security Scan (optional)') {
      when {
        expression { return false } 
      }
      steps {
        sh """
          cd ${APP_TF_DIR}
          echo "Running tfsec..."
          tfsec .
        """
      }
    }

    stage('Terraform Plan') {
      steps {
        sh """
          cd ${APP_TF_DIR}
          echo "Running terraform plan..."
          terraform plan -out=tfplan
        """
      }
    }

    stage('Terraform Apply (manual)') {
      steps {
        script {
          input message: "Apply Terraform changes in GCP (APP stack only)?", ok: "Apply"
          sh """
            cd ${APP_TF_DIR}
            echo "Applying terraform plan..."
            terraform apply tfplan
          """
        }
      }
    }

    stage('Publish Terraform Outputs (artifact)') {
      steps {
        script {
          sh """
            set -e
            cd ${APP_TF_DIR}

            APP_VM_IP=\$(terraform output -raw app_vm_internal_ip)
            APP_URL=\$(terraform output -raw app_url)
            DB_HOST=\$(terraform output -raw db_public_ip)

            cat > ../infra-outputs.env <<EOF
            APP_VM_IP=\${APP_VM_IP}
            APP_URL=\${APP_URL}
            DB_HOST=\${DB_HOST}
            EOF

            echo "Generated infra-outputs.env:"
            cat ../infra-outputs.env
          """
          archiveArtifacts artifacts: 'infra-outputs.env', fingerprint: true
        }
      }
    }


    stage('Configure App VM with Ansible') {
      steps {
        script {
          def appIp = sh(
            returnStdout: true,
            script: "cd ${APP_TF_DIR} && terraform output -raw app_vm_internal_ip"
          ).trim()

          sh """
            cd ansible
            ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${appIp},' -u tlavric playbooks/setup_app.yml
          """
        }
      }
    }

    stage('Terraform Destroy (manual)') {
      steps {
        script {
          input message: "Destroy APP infrastructure (App VM + Instance Group + Load Balancer)? Jenkins will remain.", ok: "Destroy"
          sh """
            cd ${APP_TF_DIR}
            echo "Destroying APP infrastructure..."
            terraform destroy -auto-approve
          """
        }
      }
    }
  }
}
