#!groovy
import jenkins.model.*
import hudson.security.*

def env = System.getenv()

// parameters
def jenkinsParameters = [
  email:  System.getenv('GLOBAL_CONFIG_NAME'),
  url:    System.getenv('GLOBAL_CONFIG_EMAIL')
]

// get Jenkins location configuration
def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

// set Jenkins URL
jenkinsLocationConfiguration.setUrl(jenkinsParameters.url)

// set Jenkins admin email address
jenkinsLocationConfiguration.setAdminAddress(jenkinsParameters.email)

// // Git Identity
println "--> Configuring Git Identity"
def gitGlobalConfigName = System.getenv('GIT_GLOBAL_CONFIG_NAME')
def gitGlobalConfigEmail = System.getenv('GIT_GLOBAL_CONFIG_EMAIL')
def desc_git_scm = Jenkins.instance.getDescriptor("hudson.plugins.git.GitSCM")
desc_git_scm.setGlobalConfigName(gitGlobalConfigName)
desc_git_scm.setGlobalConfigEmail(gitGlobalConfigEmail)

// save current Jenkins state to disk
jenkinsLocationConfiguration.save()