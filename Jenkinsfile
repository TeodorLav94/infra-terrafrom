pipeline {
  agent { label 'infra' }   

  environment {
    TF_IN_AUTOMATION = 'true'
    // Dacă folosești service account JSON în Jenkins:
    // GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-sa-terraform')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          terraform init -input=false
        '''
      }
    }

    stage('Terraform Format') {
      steps {
        sh '''
          echo "Running terraform fmt..."
          terraform fmt -recursive
        '''
      }
    }

    stage('Terraform Validate') {
      steps {
        sh '''
          echo "Running terraform validate..."
          terraform validate
        '''
      }
    }

    stage('Terraform Security Scan (optional)') {
      when {
        expression { return false } // pune true dacă instalezi tfsec
      }
      steps {
        sh '''
          echo "Running tfsec..."
          tfsec .
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        sh '''
          echo "Running terraform plan..."
          terraform plan -out=tfplan
        '''
      }
    }

    stage('Terraform Apply (manual)') {
      steps {
        script {
          input message: "Apply Terraform changes in GCP?", ok: "Apply"
          sh '''
            echo "Applying terraform plan..."
            terraform apply tfplan
          '''
        }
      }
    }

    stage('Terraform Destroy (manual)') {
      steps {
        script {
          input message: "Destroy ALL infrastructure in this environment?", ok: "Destroy"
          sh '''
            echo "Destroying infrastructure..."
            terraform destroy -auto-approve
          '''
        }
      }
    }
  }
}
