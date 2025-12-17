pipeline {
  agent { label 'infra' }   

  environment {
    TF_IN_AUTOMATION = 'true'
    APP_TF_DIR       = 'app'
    JENKINS_TF_DIR   = 'jenkins'
  }
  
  parameters {
    booleanParam(name: 'RUN_APPLY',   defaultValue: true,  description: 'Run terraform apply')
    booleanParam(name: 'RUN_DESTROY', defaultValue: false, description: 'Run terraform destroy')
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init (app + jenkins)') {
      steps {
        sh """
          cd ${APP_TF_DIR}
          terraform init -input=false
          cd ../${JENKINS_TF_DIR}
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

    stage('Terraform Apply') {
      when { expression { return params.RUN_APPLY } }
      steps {
        sh """
          cd ${APP_TF_DIR}
          terraform apply tfplan
        """
      }
    }

    stage('Publish Terraform Outputs (artifact)') {
      steps {
        sh """
          set -e

          # APP stack outputs
          cd ${APP_TF_DIR}
          APP_VM_IP=\$(terraform output -raw app_vm_internal_ip)
          APP_URL=\$(terraform output -raw app_url)

          # DB outputs (din stack-ul jenkins)
          cd ../${JENKINS_TF_DIR}
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

    stage('Terraform Destroy') {
      when { expression { return params.RUN_DESTROY } }
      steps {
        sh """
          cd ${APP_TF_DIR}
          terraform destroy -auto-approve
        """
      }
    }
  }
}
