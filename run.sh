pip install virtualenv
virtualenv venv
source .env
pip install -r requirements.dev.txt
python bin/start_web.py
