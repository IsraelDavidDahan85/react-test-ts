pipeline {
    agent {
        label "npm-node-agent"
    }

    stages {

        stage('Git SCM') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'main', url: 'https://github.com/IsraelDavidDahan85/react-test-ts.git'
            }

            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    script {
                        sh 'echo successfully build'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    sh 'npm install && npm run test run'
                
                }
            }
        }
        stage('Build') {
            agent {
                label "docker"
            }
            steps {
                script {
                    sh '''
                    docker build -t react-test-ts .
                    '''
                }
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    sh 'docker tag react-test-ts $DOCKER_USER/react-test-ts:$BUILD_NUMBER'
                    sh 'docker tag react-test-ts $DOCKER_USER/react-test-ts:latest'

                    sh 'docker push $DOCKER_USER/react-test-ts:$BUILD_NUMBER'
                    sh 'docker push $DOCKER_USER/react-test-ts:latest'
                }

            }
        }
        stage('SonarQube Analysis') {
            // def scannerHome = tool 'SonarScanner';
            // withSonarQubeEnv() {
            // sh "${scannerHome}/bin/sonar-scanner"
            // }

            steps {
                sh 'echo "SonarQube Analysis Done"'
                sh '''
                "${scannerHome}/bin/sonar-scanner" \
                -Dsonar.projectKey=node \
                -Dsonar.sources=. \
                -Dsonar.host.url=http://host.docker.internal:9001 \
                -Dsonar.login=sqp_4bbb613cda9b6ea815530b4927184fd5a3ad7a28
                '''
            }
        }
        stage('Tag') {
            steps {
                script {
                    // save private key to file 
                    withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                       sh '''
                            git config --global url."https://${USERNAME}:${PASSWORD}@github.com/".insteadOf https://github.com/
                            git config --global user.email "israeldaviddahan@gmail.com"
                            git config --global user.name "Israel David Dahan"

                            git tag -a v1.0.$BUILD_NUMBER -m "Version 1.0.$BUILD_NUMBER"
                            git push origin v1.0.$BUILD_NUMBER
                        '''
                        
                    }
                }
            }
        }


    }
}
