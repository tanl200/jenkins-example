@Library('github.com/tanl200/jenkins-pipeline-library') _
node {
	stage ('1st')
	firstExample {
		message = 'Test stage completed, please approved for next step'
	}

	stage ('Approve')
    approve {
    	message = 'Test stage completed, please approved for next step'
    }

    stage ('2nd')
    secondExample {}

    stage ('commit message')
    def commit = sh(returnStdout: true, script: 'git  log --format=%s%b -n 1 7326a46ec0c348864cef40caa3d6787212cad067 | cut -d ":" -f1')

    stage ('kops')
    kops {
    	action = "${commit}"
    }

}
