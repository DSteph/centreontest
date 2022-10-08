$path = $ARGV[0];

if( ! (-e $path) ) {
   print "The file at the specified path $path does not exist\n";
   exit(1);
}

open($fd, '<', $ARGV[0]) or die("Could not open the file at specified path $path\n");


@charSeparators = ( ',', '.' ); 
$lines, $words, $chars = 0;
# Reading and counting each line using chomp
while( defined( $l = <$fd> ) ) {
   chomp $l;
   ++$lines;
   # Counting chars and words, reading the very first char to get the loop going smooth
   $firstChar = substr($l, 0, 1);
   if ( grep( /^$firstChar$/, @charSeparators ) || $firstChar eq " " ){
      $isWord = 0; # Will be true if last char was part of a word, cd not a delimiter
   }
   else {
      $isWord = 1;
   }

   # We consider the blank not to be counted as a character
   foreach $byte (split //, $l) {
      switch ( $byte ) {
         # Simplest to more complex to save processing time
         case ( $isWord )                                                                          { ++$chars }
         case ( $byte = " " && $isWord )                                                           { ++$words; $isWord=0 }
         case ( grep( /^$byte$/, @charSeparators ) && $isWord )                                    { ++$chars; ++$words; $isWord=0 }
         case ( ( !( grep( /^$byte$/, @charSeparators ) ) || !( $byte eq " " ) ) && !$isWord )     { ++$chars; $isWord=1 }

      }
   }
   
   print "lines : $lines\n";
   print "words : $words\n";
   print "chars : $chars\n";
}