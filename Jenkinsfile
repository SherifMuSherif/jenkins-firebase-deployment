pipeline {
    agent any

    environment {
        FIREBASE_TOKEN = credentials('firebase-token')
        TF_VAR_docker_host = 'unix:///var/run/docker.sock'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-token', url: 'https://github.com/SherifMuSherif/jenkins-firebase-deployment.git'
            }
        }
        stage('Terraform Init') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh '''
                    cd terraform-phase1
                    terraform init
                '''
            }
        }
        stage('Terraform Plan') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh '''
                    cd terraform-phase1
                    terraform plan -out=tfplan
                '''
            }
        }
        stage('Approve Terraform') {
            steps {
                input message: 'Apply Terraform changes?', ok: 'Deploy Infrastructure'
            }
        }
        stage('Terraform Apply') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh '''
                    cd terraform-phase1
                    terraform apply -auto-approve tfplan
                '''
            }
        }
        stage('Build & Verify') {
            agent {
                docker {
                    image 'node:18'
                }
            }
            steps {
                sh 'node --version'
                echo '✅ Build environment verified'
            }
        }
        stage('Deploy to Testing') {
            agent {
                docker {
                    image 'node:18'
                }
            }
            steps {
                sh '''
      npm install -g firebase-tools
      firebase deploy -P testing --token "$FIREBASE_TOKEN"
    '''
            }
        }
        stage('Approve Staging') {
            steps {
                input message: 'Deploy to STAGING?', ok: 'Proceed'
            }
        }
        stage('Deploy to Staging') {
            agent {
                docker {
                    image 'node:18'
                }
            }
            steps {
                sh '''
      npm install -g firebase-tools
      firebase deploy -P staging --token "$FIREBASE_TOKEN"
    '''
            }
        }
        stage('Approve Production') {
            steps {
                input message: 'Deploy to PRODUCTION?', ok: 'Proceed'
            }
        }
        stage('Deploy to Production') {
            agent {
                docker {
                    image 'node:18'
                }
            }
            steps {
                sh '''
      npm install -g firebase-tools
      firebase deploy -P production --token "$FIREBASE_TOKEN"
    '''
            }
        }
    }
}
