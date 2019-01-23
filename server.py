from flask import Flask
from healthcheck import HealthCheck
import connexion
import configparser
import socket

app = connexion.App(__name__, specification_dir="./")

# wrap the flask app and give a heathcheck url
health = HealthCheck(app, "/api/health")

# set parser globally
config = configparser.ConfigParser()
config._interpolation = configparser.ExtendedInterpolation()


@app.route("/")
def hello():
    config.read('config/hello.ini')
    return "Hello {0} from {1}.".format(config['FROM']['name'], socket.gethostname())


if __name__ == "__main__":
    app.run()
