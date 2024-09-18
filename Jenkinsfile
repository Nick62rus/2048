pipeline {
    agent any
    environment {
        IMAGE_NAME = 'nick62rus/game'
        KUBECONFIG = credentials('k8s-credentials-id')
    }
    
    stages {
        stage("Git Clone") {
            steps {
                echo "STAGE 1 - GIT CLONE"
                git 'https://github.com/Nick62rus/2048.git'
                echo "STAGE 1 GIT CLONE - COMPLETE"
            }
        }    
        
        stage('Build') {
            steps {
                echo "STAGE 2 BUILD DOCKER IMAGE"
                    sh "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} ." // Сборка образа
                    sh "docker tag ${IMAGE_NAME}:${env.BUILD_NUMBER} ${IMAGE_NAME}:latest"
                    echo "STAGE 2 BUILD DOCKER IMAGE - COMPLETE"
                }
            }
            
        stage('PUSH') {
            steps {
                echo "STAGE 3 PUSH TO DOCKERHUB"
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_TOKEN')]) {
                    sh "docker push ${IMAGE_NAME}:${env.BUILD_NUMBER}" // Пуш образа в Docker Hub
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
                    
        stage('DEPLOY TO CLUSTER k8s') {
            steps{
                echo "STAGE 4 DEPLOY"
                sh 'kubectl apply -f ./k8s/deployment.yml'
                }
            }
    
    }
    

    post {
        success {
            script {
                def message = "Сборка ${env.JOB_NAME} #${env.BUILD_NUMBER} завершена успешно!✅✅✅"
                sendTelegramNotification(message)
            }
        }
        failure {
            script {
                def message = "Сборка ${env.JOB_NAME} #${env.BUILD_NUMBER} завершилась с ошибкой.❌❌❌"
                sendTelegramNotification(message)
            }
        }
        always {
            script {
                sh """
                docker rmi ${IMAGE_NAME}:${env.BUILD_NUMBER} || true
                docker rmi ${IMAGE_NAME}:latest || true
                """
            }
        }
    }
}    
def sendTelegramNotification(String message) {
    withCredentials([
        string(credentialsId: 'telegram-bot-token', variable: 'TELEGRAM_BOT_TOKEN'),
        string(credentialsId: 'telegram-chat-id', variable: 'TELEGRAM_CHAT_ID')
        ]) {
            sh """
                curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \
                -d chat_id=${TELEGRAM_CHAT_ID} \
                -d text="${message}"
            """
            }
   }