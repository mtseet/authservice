echo "reset"
RESULT=$(curl http://localhost:8000/reset 2> /dev/null) 
if [[ "$RESULT" == *OK* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

echo "auth validate with non existent token"
RESULT=$(curl http://localhost:8000/authvalidate?token=abc 2> /dev/null) 
if [[ "$RESULT" == *Invalid* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi


echo "logout with non existent token"
RESULT=$(curl http://localhost:8000/logout?token=abc 2> /dev/null) 
if [[ "$RESULT" == *Invalid* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

echo "register"
RESULT=$(curl -X POST -H "Content-Type: application/json" -d '{"username":"user", "password":"1234"}' http://localhost:8000/register 2> /dev/null) 
if [[ "$RESULT" == *OK* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

echo "authenticate"
RESULT=$(curl -X POST -H "Content-Type: application/json" -d '{"username":"user", "password":"1234"}' http://localhost:8000/auth 2> /dev/null) 
if [[ "$RESULT" == *OK* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

echo "authenticate with invalid username"
RESULT=$(curl -X POST -H "Content-Type: application/json" -d '{"username":"userx", "password":"1234"}' http://localhost:8000/auth 2> /dev/null) 
if [[ "$RESULT" == *Invalid* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

echo "authenticate with invalid password"
RESULT=$(curl -X POST -H "Content-Type: application/json" -d '{"username":"user", "password":"1234x"}' http://localhost:8000/auth 2> /dev/null) 
if [[ "$RESULT" == *Invalid* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

echo "token validate"
RESULT=$(curl http://localhost:8000/authvalidate?token=1234 2> /dev/null) 
if [[ "$RESULT" == *OK* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

echo "register with existing username"
RESULT=$(curl -X POST -H "Content-Type: application/json" -d '{"username":"user", "password":"1234"}' http://localhost:8000/register 2> /dev/null) 
if [[ "$RESULT" == *'Account not available'* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

echo "logout"
RESULT=$(curl http://localhost:8000/logout?token=1234 2> /dev/null) 
if [[ "$RESULT" == *OK* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

echo "token validate after logout"
RESULT=$(curl http://localhost:8000/authvalidate?token=1234 2> /dev/null) 
if [[ "$RESULT" == *Invalid* ]]; then
   echo "OK ${RESULT}"
else
   echo "FAILED ${RESULT}"
fi

loadtest -n 1 -c 1 -m POST -T "application/json" -P '{"username":"user", "password":"1234"}' http://localhost:8000/auth


