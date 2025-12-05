pipeline {
  agent { label 'infra' }   // același agent / node ca înainte

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

    stage('Terraform Destroy (manual)') {
      steps {
        script {
          input message: "Destroy APP infrastructure (App VM + Instance Group + Load Balancer)? Jenkins va rămâne în picioare.", ok: "Destroy"
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
