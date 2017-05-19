from os import environ as env


class Config(object):

    ENVIRONMENT = env.get('ACME_FREIGHT_ENV', 'DEV').upper()
    SECRET = env.get('SECRET', 'secret')

    OPENWHISK_URL = env.get('OPENWHISK_URL', 'https://openwhisk.ng.bluemix.net')
    OPENWHISK_AUTH = env.get('OPENWHISK_AUTH')
    OPENWHISK_PACKAGE = env.get('OPENWHISK_PACKAGE', 'lwr')

    OPENWHISK_API_KEY = env.get('OW_API_KEY')
    OPENWHISK_API_URL = env.get('OW_API_URL')

    APIC_CLIENT_ID = env.get('APIC_CLIENT_ID')
    APIC_CLIENT_SECRET = env.get('APIC_CLIENT_SECRET')