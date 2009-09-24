/*
 The Computer Language Benchmarks Game
 http://shootout.alioth.debian.org/

 contributed by Ian Martins
*/
class Fasta
{
  private static var rnd : FastaRandom;

  public static function main()
  {
    var alu = 'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG'
      + 'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA'
      + 'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT'
      + 'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA'
      + 'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG'
      + 'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC'
      + 'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA';

    var iubChar = 'acgtBDHKMNRSVWY';
    var iubProb = [0.27, 0.12, 0.12, 0.27, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02];

    var homosapiensChar = 'acgt';
    var homosapiensProb = [0.3029549426680, 0.1979883004921, 0.1975473066391, 0.3015094502008];

    var nn = Std.parseInt(neko.Sys.args()[0]);
    rnd = new FastaRandom();

    neko.Lib.println('>ONE Homo sapiens alu');
    repeatFasta(alu, nn*2);

    neko.Lib.println('>TWO IUB ambiguity codes');
    randomFasta(iubChar, iubProb, nn*3);

    neko.Lib.println('>THREE Homo sapiens frequency');
    randomFasta(homosapiensChar, homosapiensProb, nn*5);
  }

  public static function repeatFasta(src:String, nn:Int)
  {
    var width = 60;
    var rr = src.length;
    var ss = src+src+src.substr(0,nn%rr);
    var ii = 0;
    for( jj in 0...Std.int(nn/width) )
    {
      ii = (jj*width) % rr;
      neko.Lib.println(ss.substr(ii, width));
    }

    if( (nn%width) != 0 )
      neko.Lib.println(ss.substr(-(nn%width)));
  }

  public static function makeCumulative(tableProb:Array<Float>)
  {
    var probList = new List<Float>();
    var prob = 0.0;
    for( ii in 0...tableProb.length)
    {
      prob += tableProb[ii];
      probList.add(prob);
    }
    return probList;
  }

  public static function randomFasta(tableChar, tableProb, nn)
  {
    var width = 60;
    var probList = makeCumulative(tableProb);
    for( ii in 0...Math.floor(nn/width) )
    {
      for( jj in 0...width )
	neko.Lib.print(tableChar.charAt(bisect(probList, rnd.genRandom())));
      neko.Lib.println('');
    }
    for( jj in 0...nn%width )
      neko.Lib.print(tableChar.charAt(bisect(probList, rnd.genRandom())));
    if( nn%width != 0 )
      neko.Lib.println('');
  }

  // replace this with binary search
  public static function bisect(list:List<Float>, item:Float)
  {
    var ret=0;
    var iter = list.iterator();
    while( iter.hasNext() )
    {
      if( item < iter.next() )
	return ret;
      else
	ret++;
    }
    return -1;
  }
}

/*
def randomFasta(table, n):
    width = 60
    r = xrange(width)
    gR = Random.next
    bb = bisect.bisect
    jn = ''.join
    probs, chars = makeCumulative(table)
    for j in xrange(n // width):
        print jn([chars[bb(probs, gR())] for i in r])
    if n % width:
        print jn([chars[bb(probs, gR())] for i in xrange(n % width)])
*/