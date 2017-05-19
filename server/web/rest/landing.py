"""
The REST interface for the root API
"""
from flask import Response, Blueprint, redirect

landing_blueprint = Blueprint('landing', __name__)

@landing_blueprint.route('/', methods=['GET'])
def landing():
    return 'This is the Acme Freight Controller API. Did you mean to visit UI instead?'
