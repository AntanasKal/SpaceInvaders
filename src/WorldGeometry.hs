{-# LANGUAGE CPP #-}
-- |
-- Module      : WorldGeometry
-- Description : Constants and functions defining the geometry of the world.
-- Copyright   : (c) Yale University, 2003
--
-- Author: Henrik Nilsson
module WorldGeometry where

-- External imports
import           Data.Point2  (Point2 (..))
#if !WASM_BUILD
import qualified Graphics.HGL as HGL (Point)
#else
import qualified HGLSubstitutes as HGL (Point)
#endif
-- Internal imports
import PhysicalDimensions

-- Everything in the world is measured in meters.

pixelsPerMeter :: InvaderReal
pixelsPerMeter = 0.5

pixelsToMeters :: Int -> Length
pixelsToMeters p = (fromIntegral p) / pixelsPerMeter

metersToPixels :: Length -> Int
metersToPixels m = round (m * pixelsPerMeter)


-- The world is assumed to be rectangular.

worldXMin, worldXMax :: Position
worldYMin, worldYMax :: Position
worldXMin = -500.0
worldYMin = 0.0
worldXMax = 500.0
worldYMax = 1000.0


-- World size in pixels.

worldSizeX, worldSizeY :: Int
worldSizeX = metersToPixels (worldXMax - worldXMin)
worldSizeY = metersToPixels (worldYMax - worldYMin)


-- -- !!! We don't need any walls???
--
-- -- Positions of the walls.
--
-- worldNorthWall, worldSouthWall :: Position
-- worldEastWall, worldWestWall :: Position
-- worldNorthWall = worldYMax - 0.2
-- worldEastWall  = worldXMax - 0.2
-- worldSouthWall = worldYMin + 0.2
-- worldWestWall  = worldXMin + 0.2


-- Co-ordinate translations

-- Re-visit these definitions if/once affine transforms are introduced in AFRP.
-- Maybe use affine transformations also for the basic conversions HGL.Point
-- <-> Position2?

-- pointToPositionT :: Transform2
-- pointToPositionT = translate2 (vector2XY worldXMin worldYMax) `compose2`
--                    uscale2 (1 / pixelsPerMeter) `compose2`
--                    mirrorY2


gPointToPosition2 :: HGL.Point -> Position2
gPointToPosition2 (x, y) = (Point2 (pixelsToMeters x + worldXMin)
                                   (worldYMax - pixelsToMeters y))


-- positionToPointT :: Transform2
-- positionToPointT = uscale2 pixelsPerMeter `compose2`
--                    translate2 (vector2XY (-worldXMin) worldYMax) `compose2`
--                    mirrorY2


position2ToGPoint :: Position2 -> HGL.Point
position2ToGPoint (Point2 x y) =
    (metersToPixels (x - worldXMin), metersToPixels (worldYMax - y))
