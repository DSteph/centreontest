use JSON;

# My hope is that this saves processing time, but it probably doesn't
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
      $isWord = 0; # Will be true if last char was part of a word, cf not a delimiter
   }
   else {
      $isWord = 1;
   }
   # We consider the blank not to be counted as a character
   foreach $byte (split //, $l) {

      if ( ( $byte eq " " ) && $isWord )                                                         { ++$words; $isWord=0; }
      elsif ( grep( /^$byte$/, @charSeparators ) && $isWord )                                    { ++$chars; ++$words; $isWord=0 }
      elsif ( ( !( grep( /^$byte$/, @charSeparators ) ) || !( $byte eq " " ) ) && !$isWord )     { ++$chars; $isWord=1 }
      elsif ( $isWord )                                                                          { ++$chars }

   }
}

# We create the json at the same path as origin file
$savePath = substr( $path, 0, rindex( $path, "." ) ) . '_parsed.json';
$name = substr( $path, rindex( $path, "/" ) + 1 );

%output = ( 'Name'=> $name, 'Lines' => $lines, 'Words' => $words, 'Characters' => $chars );
# JSON Output will be unordered
$json = encode_json \%output;

open( $fd2,'>',$savePath ) or die( "Could not write the file at path $savePath\n" );
print( $fd2 $json );