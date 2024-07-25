pipeline {
    agent {
        label 'AGENT-1'
    }
    options { 
        // Timeout counter starts BEFORE agent is allocated
        timeout(time: 30, unit: 'MINUTES') 
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    stages {
        stage('Init') {
            steps {
                sh """
                 cd 01-vpc
                 terraform init -reconfigure
                """
            }
        }
        stage('Plan') {   
            steps {
                sh """
                 cd 01-vpc
                 terraform plan
                """
            }
        }
        stage('Deploy') {
            input {
                message "Should we continue?"
                ok "Yes, we should."
             } 
            steps {
                sh """
                 cd 01-vpc
                 terraform apply -auto-approve
                """
            }
        }
        stage('Destroy') {
            steps {
                sh """
                 cd 01-vpc
                 terraform destroy -auto-approve
                """
            }
        }
    }
    post { 
        always { 
            echo 'I will always say Hello again!'
            deleteDir()
        }
        success{
            echo 'I will when pipeline is success'
        }
        failure{
            echo 'I will when pipeline is failure'
        }
    }
}
    