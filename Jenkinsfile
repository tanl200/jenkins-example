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

    stage ('kops')
    def result = kops {
    	action = "create"
    }
    
    if ( result == 0) {
    	currentBuild.result = 'FAILED'
    	def output = readFile('create.log').trim()
    	sh "echo ${output}"
    }
}
