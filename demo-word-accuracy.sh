#!/bin/sh
## scipt for computing the vectors  and checking the accuracy with google's questions-words analogy task
if [ ! -e text8 ]; then
    wget https://dl.dropboxusercontent.com/u/39534006/text8.zip 
    unzip text8.zip
fi
home=$HOME
factorielib="${home}/.m2/repository/cc/factorie/factorie/1.0-SNAPSHOT/factorie-1.0-SNAPSHOT.jar"
scalalib="${home}/.m2/repository/org/scala-lang/scala-library/2.10.2/scala-library-2.10.2.jar"
wordvec="wordvec.jar"
gcc compute-accuracy.c -o compute-accuracy -lm ## google's word2vec code
mvn compile; mvn compile;
if [ $? -eq 0 ]; then
 cd target/classes
 jar cf ${wordvec} .
 mv ${wordvec} ../../${wordvec}
 cd ../..
 wordvecjar=$wordvec
 java -Xmx10g -cp "${wordvecjar}:${factorielib}:${scalalib}" WordVec --cbow=0 --train text8 --output vectors.txt --size=200 --window=5 --sample=0.001 --min-count=5 --max-count=150 --threads=21 --save-vocab=text8.vocab 
  if [ $? -eq 0 ]; then
    ./compute-accuracy vectors.txt 30000 < questions-words.txt
    # to compute accuracy with the full vocabulary, use: ./compute-accuracy vectors.txt < questions-words.txt
  fi
fi

