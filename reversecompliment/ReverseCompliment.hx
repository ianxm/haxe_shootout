/*
  The Computer Language Benchmarks Game
  http://shootout.alioth.debian.org/

  contributed by Ian Martins
*/
class ReverseCompliment
{
  private static var table : Hash<String>;

  public static function main()
  {
    var keys = 'ACBDGHKMNSRUTWVYacbdghkmnsrutwvy';
    var vals = 'TGVHCDMKNSYAAWBRTGVHCDMKNSYAAWBR';
    table = new Hash<String>();
    for( ii in 0...keys.length )
      table.set(keys.charAt(ii), vals.charAt(ii));

    var seq = new List<String>();
    var fin = neko.io.File.stdin();
    try
    {
      var line;
      while( true )
      {
	line = fin.readLine();
	if( line.charAt(0) == '>' )
	{
	  show(seq);
	  neko.Lib.println(line);
	  seq.clear();
	}
	else
	  seq.add(line);
      }
    }
    catch ( ex:haxe.io.Eof ) {}
    show(seq);
  }

  private static function show(seq : List<String>)
  {
    var str = seq.join('');
    var ii=str.length-1;
    var jj=0;
    var buf = new StringBuf();
    while (ii>=0)
    {
      buf.add(table.get(str.charAt(ii)));
      jj++; ii--;
      if( jj%60 == 0 )
      {
	neko.Lib.println(buf.toString());
	buf = new StringBuf();
      }
    }
    if( str.length%60 != 0 )
      neko.Lib.println(buf.toString());
  }
}