print "supervised-disambiguate.pl $train  --directory $log --test $test --weka \"weka.classifiers.meta.AttributeSelectedClassifier -E \\\"weka.attributeSelection.InfoGainAttributeEval -M\\\" -S \\\"weka.attributeSelection.Ranker -T 0.0 -N -1\\\" -W weka.classifiers.functions.SMO\" --ngramcount \"--ngram 1 --frequency 2\" --stop $stoplist --lc\n";