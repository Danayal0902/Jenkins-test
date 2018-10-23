pipeline {

   agent {
       node {
           label 'master'
       }
    //   kubernetes {
    //      label 'jenkins-slave'
    //      yamlFile 'kube-terraform.yaml'
    //   }
   }

   stages {
    //   stage('Keys') {
    //      steps {
    //         container('terraform') {
    //            sh "rm -rf ~/.ssh/ && mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
    //         }
    //      }
    //   }

      stage('init') {
          steps {
              sh """
                ${TERRAFORM_CMD} init -backend=true -input=false
                """
          }
      }

      stage('plan') {
          steps {
              sh """
                ${TERRAFORM_CMD} plan -out=tfplan -input=false
                """
              script {
                  timeout(time: 10, unit: 'MINUTES') {
                      input(id: "Deploy", "Deploy ${params.project_name}?", ok: 'Deploy')
                  }
              }  
          }
      }

      stage('apply') {
          steps {
              sh """
                ${TERRAFORM_CMD} apply -lock=false -input=false -auto-approve
                -var aws_access_key=${env.AWS_ACCESS_KEY_ID} -var aws_secret_key=${env.AWS_SECRET_ACCESS_KEY} 
                tfplan
                output address
                """
                // This should be added to persistent storage so the app pipeline script can read it
          }
      }

    //   stage('Deploy-Infrastructure') {
    //      steps {
    //         echo 'Initialising Infrastructure...'
    //         container('terraform') {
    //            sh 'terraform init'
    //            sh "terraform apply -auto-approve -var aws_access_key=${env.AWS_ACCESS_KEY_ID} -var aws_secret_key=${env.AWS_SECRET_ACCESS_KEY}"
    //            // This should be added to persistent storage so the app pipeline script can read it
    //            sh 'terraform output address'
    //         }
    //      }
    //   }

   }
}
