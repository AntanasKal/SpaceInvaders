{-# LANGUAGE CPP #-}
-- |
-- Module      : RenderLandscape
-- Description : Rendering of the fixed backdrop.
-- Copyright   : (c) Yale University, 2003
--
-- Author: Henrik Nilsson
module RenderLandscape (
    landscape           -- :: HGL.Graphic
) where

-- External imports
import           Data.Array
import           Data.Point2  (Point2 (..))
#if !WASM_BUILD
import qualified Graphics.HGL as HGL
#else
import qualified HGLSubstitutes as HGL
import RenderObject
#endif
-- Internal imports
import ColorBindings
import Colors
import WorldGeometry


------------------------------------------------------------------------------
-- Landscape rendering
------------------------------------------------------------------------------

#if !WASM_BUILD
landscape :: HGL.Graphic
landscape =
    HGL.mkBrush (colorTable ! distantMountainColor) $ \dmcBrush ->
    HGL.mkBrush (colorTable ! closeMountainColor) $ \cmcBrush ->
    HGL.mkBrush (colorTable ! groundColor) $ \groundBrush ->
    HGL.overGraphics
        [ HGL.withBrush groundBrush $ HGL.polygon groundPoints,
          HGL.withBrush cmcBrush    $ HGL.polygon cmPoints,
          HGL.withBrush dmcBrush    $ HGL.polygon dmPoints
        ]
#else
landscape :: IO ()
landscape = do
  polygon distantMountainColor (map gPointToPosition2 dmPoints)
  polygon closeMountainColor (map gPointToPosition2 cmPoints)
  polygon groundColor (map gPointToPosition2 groundPoints)
#endif

-- Points defining the distant mountain chain.
dmPoints :: [HGL.Point]
dmPoints = map relativeToGPoint
               [ (0.00, 0.00),
                 (0.00, 0.62),
                 (0.11, 0.20),
                 (0.42, 0.33),
                 (0.51, 0.24),
                 (0.60, 0.37),
                 (0.68, 0.17),
                 (0.81, 0.26),
                 (0.94, 0.39),
                 (1.00, 0.50),
                 (1.00, 0.00)
               ]

-- Points defining the close mountain chanin.
cmPoints :: [HGL.Point]
cmPoints = map relativeToGPoint
               [ (0.00, 0.00),
                 (0.15, 0.25),
                 (0.35, 0.00),
                 (0.80, 0.20),
                 (0.90, 0.00)
               ]

-- Points defining the ground.
groundPoints :: [HGL.Point]
groundPoints = map relativeToGPoint
                   [ (0.00, 0.00),
                     (0.00, 0.05),
                     (1.00, 0.05),
                     (1.00, 0.00)
                   ]


relativeToGPoint :: (Double, Double) -> HGL.Point
relativeToGPoint (x,y) = (round (x * fromIntegral worldSizeX),
                          round ((1.0 - y) * fromIntegral worldSizeY))
