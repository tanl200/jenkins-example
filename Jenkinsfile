@Library('github.com/tanl200/jenkins-pipeline-library') _
node {

	checkout scm

	def commit = ''

	stage ('1st') {
		firstExample {
			message = 'Test stage completed, please approved for next step'
		}	
	}


	stage ('Approve') {
	    approve {
	    	message = 'Test stage completed, please approved for next step'
	    }	
	}


    stage ('2nd') {
	    secondExample {}    
    }


    stage ('commit message') {
	    sh(returnStdout: true, script: "git log --format=%s%b -n 1 \$(git rev-parse HEAD)  > commit.log")
	    commit = readFile('commit.log').split(":")[0]
    }

    stage ('kops') {
    	sh 'echo ${commit}'
	    kops {
	    	action = "${commit}"
	    }    
    }


}
