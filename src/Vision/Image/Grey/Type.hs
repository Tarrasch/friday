{-# LANGUAGE BangPatterns, GeneralizedNewtypeDeriving, TypeFamilies #-}

module Vision.Image.Grey.Type (
      Grey, GreyPixel (..), GreyDelayed
    ) where

import Data.Bits
import Data.Word
import Foreign.Storable (Storable)

import Vision.Image.Interpolate (Interpolable (..))
import Vision.Image.Transform (
      InterpolMethod, crop, resize, horizontalFlip, verticalFlip
    )
import Vision.Image.Type (Pixel (..), Manifest, Delayed)
import Vision.Primitive (Rect, Size)

newtype GreyPixel = GreyPixel Word8
    deriving (Bits, Bounded, Enum, Eq, FiniteBits, Integral, Num, Ord, Real
            , Read, Show, Storable)

type Grey = Manifest GreyPixel

type GreyDelayed = Delayed GreyPixel

instance Pixel GreyPixel where
    type PixelChannel GreyPixel = Word8

    pixNChannels _ = 1
    {-# INLINE pixNChannels #-}

    pixIndex !(GreyPixel v) _ = v
    {-# INLINE pixIndex #-}

instance Interpolable GreyPixel where
    interpol f (GreyPixel a) (GreyPixel b) = GreyPixel $ f a b
    {-# INLINE interpol #-}

{-# SPECIALIZE crop           :: Rect -> Grey -> Grey #-}
{-# SPECIALIZE resize         :: InterpolMethod -> Size -> Grey -> Grey #-}
{-# SPECIALIZE horizontalFlip :: Grey -> Grey #-}
{-# SPECIALIZE verticalFlip   :: Grey -> Grey #-}
