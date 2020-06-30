import jenkins.*
import jenkins.model.*
import hudson.model.*
import jenkins.model.Jenkins
import org.jenkinsci.plugins.authorizeproject.*
import org.jenkinsci.plugins.authorizeproject.strategy.*
import jenkins.security.QueueItemAuthenticatorConfiguration

def instance = Jenkins.getInstance()

// Define which strategies you want to allow to be set per project
def strategyMap = [
  (instance.getDescriptor(AnonymousAuthorizationStrategy.class).getId()): false, 
  (instance.getDescriptor(TriggeringUsersAuthorizationStrategy.class).getId()): false,
  (instance.getDescriptor(SpecificUsersAuthorizationStrategy.class).getId()): true,
  (instance.getDescriptor(SystemAuthorizationStrategy.class).getId()): false
]

def authenticators = QueueItemAuthenticatorConfiguration.get().getAuthenticators()
authenticators.clear()
authenticators.add(new ProjectQueueItemAuthenticator(strategyMap))

instance.save()