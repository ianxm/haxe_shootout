class FastaRandom
{
  private var lim : Int;
  private var ia : Int;
  private var ic : Int;
  private var im : Int;
  private var seed : Int;

  public function new()
  {
    lim = 1;
    ia = 3877;
    ic = 29573;
    im = 139968;
    seed = 42;
  }

  public function genRandom()
  {
    seed = (seed * ia + ic) % im;
    return lim * seed / im;
  }
}