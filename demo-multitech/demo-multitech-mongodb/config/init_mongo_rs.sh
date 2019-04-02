if [ "${AUTO_INIT_RS}" = "1" ]; then
  echo "Checking replica sets configuration... (in 30s)"
  sleep 30
  RS_IS_INIT=`mongo localhost:27017/admin --eval "db.auth(\"${MONGO_INITDB_ROOT_USERNAME}\", \"${MONGO_INITDB_ROOT_PASSWORD}\") ; rs.conf() ;" | grep "replicaSetId" | wc -l`
  if [ "${RS_IS_INIT}" != "1" ]; then
    echo "Replica sets must be initialized"
    mongo localhost:27017/admin --eval "db.auth(\"${MONGO_INITDB_ROOT_USERNAME}\", \"${MONGO_INITDB_ROOT_PASSWORD}\") ; rs.initiate() ;"
    mongo localhost:27017/admin --eval "db.auth(\"${MONGO_INITDB_ROOT_USERNAME}\", \"${MONGO_INITDB_ROOT_PASSWORD}\") ; rs.add(\"demo-multitech-mongodb-node-2\") ;"
    mongo localhost:27017/admin --eval "db.auth(\"${MONGO_INITDB_ROOT_USERNAME}\", \"${MONGO_INITDB_ROOT_PASSWORD}\") ; rs.addArb(\"demo-multitech-mongodb-node-arb:30000\") ;"
  else
    echo "Replica sets already initialized"
  fi
fi
