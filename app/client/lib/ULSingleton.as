// Unlight
// Copyright(c)2019 CPA This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

package
{
  public class ULSingleton
  {
      private static var __instance:ULSingleton;

      function ULSingleton(caller:Function=null):void
      {
          if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");

          trace("create new instance.");
      }

      private static function createInstance():ULSingleton
      {
          return new ULSingleton(arguments.callee);
      }

      public static function get instance():ULSingleton
      {
          if( __instance == null ){
              __instance = createInstance();
          }
          return __instance;
      }
  }
}
