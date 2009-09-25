/*
  The Great Computer Language Shootout
  http://shootout.alioth.debian.org/

  contributed by Ian Martins
*/
import neko.vm.Thread;

class ThreadRing
{
  public static function main()
  {
    var threads = new Array<Thread>();
    var nThreads = 503;
    for( tt in 0...nThreads )
    {
      var newThread = Thread.create(tRun);
      newThread.sendMessage(Thread.current());
      newThread.sendMessage(tt+1);
      threads.push(newThread);
    }
    for( tt in 0...nThreads )
      threads[tt].sendMessage(threads[(tt+1)%nThreads]);

    var numPasses = Std.parseInt(neko.Sys.args()[0]);
    threads[0].sendMessage(numPasses);

    Thread.readMessage(true);
  }

  public static function tRun()
  {
    var main : Thread = Thread.readMessage(true);
    var num  : Int    = Thread.readMessage(true);
    var next : Thread = Thread.readMessage(true);

    while( true )
    {
      var val : Int = Thread.readMessage(true);
      if( val>0 )
	next.sendMessage(val-1);
      else
      {
	neko.Lib.println(num);
	main.sendMessage('done');
      }
    }
  }
}