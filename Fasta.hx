/*
 The Computer Language Benchmarks Game
 http://shootout.alioth.debian.org/

 contributed by Ian Martins
*/
class Fasta
{
  private var rnd : Float;

  private var aluChar : String;

  private var iubChar : String;
  private var iubProb : Array<Float>;

  private var homosapiensChar : String;
  private var homosapiensProb : Array<Float>;

  public function new()
  {
    rnd = 42;

    aluChar = 'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG'
      + 'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA'
      + 'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT'
      + 'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA'
      + 'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG'
      + 'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC'
      + 'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA';

    iubChar = 'acgtBDHKMNRSVWY';
    iubProb = [0.27, 0.12, 0.12, 0.27, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02];

    homosapiensChar = 'acgt';
    homosapiensProb = [0.3029549426680, 0.1979883004921, 0.1975473066391, 0.3015094502008];
  }

  public static function main()
  {
    var nn = Std.parseInt(neko.Sys.args()[0]);
    var fasta = new Fasta();
    fasta.run(nn);
  }

  public function run(nn)
  {
    neko.Lib.println('>ONE Homo sapiens alu');
    repeatFasta(aluChar, nn*2);

    neko.Lib.println('>TWO IUB ambiguity codes');
    randomFasta(iubChar, iubProb, nn*3);

    neko.Lib.println('>THREE Homo sapiens frequency');
    randomFasta(homosapiensChar, homosapiensProb, nn*5);
  }

  public function repeatFasta(src:String, nn:Int)
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

  public function genRandom()
  {
    var lim = 1;
    var ia = 3877;
    var ic = 29573;
    var im = 139968;

    rnd = (rnd * ia + ic) % im;
    return lim * rnd / im;
  }

  public function makeCumulative(tableProb:Array<Float>)
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

  public function randomFasta(tableChar, tableProb, nn)
  {
    var width = 60;
    var probList = makeCumulative(tableProb);
    for( ii in 0...Math.floor(nn/width) )
    {
      for( jj in 0...width )
	neko.Lib.print(tableChar.charAt(bisect(probList, genRandom())));
      neko.Lib.println('');
    }
    for( jj in 0...nn%width )
      neko.Lib.print(tableChar.charAt(bisect(probList, genRandom())));
    if( nn%width != 0 )
      neko.Lib.println('');
  }

  // replace this with binary search
  public function bisect(list:List<Float>, item:Float)
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
