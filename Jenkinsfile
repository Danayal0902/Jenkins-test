pipeline {

   agent {
       node {
           label 'master'
       }
    //   docker {
    //      image 'hashicorp/terraform:light'
    //      args '--entrypoint ""'
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
              sh 'terraform init -force-copy'
          }
      }

      stage('validate') {
          steps {
              sh 'terraform validate'
          }
      }

      stage('plan') {
          steps {
              sh "terraform get && terraform plan"
          }
      }

      stage('apply') {
          steps {
            sh "terraform get && apply -auto-approve -var aws_access_key=${env.AWS_ACCESS_KEY_ID} -var aws_secret_key=${env.AWS_SECRET_ACCESS_KEY}"
            sh "terraform output address"
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
