/* The Computer Language Benchmarks Game
   http://shootout.alioth.debian.org/

   contributed by Ian Martins
*/

import neko.Sys;
import neko.Lib;

class BinaryTrees
{
  inline private static var minDepth = 4;

  public static function main()
  {
    var num = Std.parseInt(Sys.args()[0]);

    var maxDepth = (minDepth+2 > num) ? minDepth+2 : num;
    var stretchDepth = maxDepth + 1;

    var check = TreeNode.bottomUpTree(0, stretchDepth).itemCheck();
    Lib.println("stretch tree of depth "+stretchDepth+"\t check: " + check);

    var longLivedTree = TreeNode.bottomUpTree(0, maxDepth);

    var depth = minDepth;
    while( depth <= maxDepth )
    {
      var iterations = 1 << (maxDepth - depth + minDepth);
      check = 0;

      for( ii in 1...iterations+1 )
      {
	check += TreeNode.bottomUpTree(ii, depth).itemCheck();
	check += TreeNode.bottomUpTree(-ii, depth).itemCheck();
      }
      Lib.println((iterations*2) + "\t trees of depth " + depth + "\t check: " + check);
      
      depth += 2;
    }
    Lib.println("long lived tree of depth " + maxDepth + "\t check: "+ longLivedTree.itemCheck());
  }
}

class TreeNode
{
  private var left :TreeNode;
  private var right :TreeNode;
  private var item :Int;

  public function new(item, ?left :TreeNode, ?right :TreeNode)
  {
    this.item = item;
    this.left = left;
    this.right = right;
  }

  public static function bottomUpTree(item, depth)
  {
    if( depth>0 )
      return new TreeNode(item,
			  bottomUpTree(2*item-1, depth-1),
			  bottomUpTree(2*item, depth-1));
    else
      return new TreeNode(item);
  }

  public function itemCheck()
  {
    return if( left == null )
      item;
    else
      item+left.itemCheck()-right.itemCheck();
  }
}