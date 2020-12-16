--[[----------------------------------------------------------------------------

  Showing the image and pointcloud acquired by Visionary-T AP side-by-side.
    
------------------------------------------------------------------------------]]

-- Setup camera
local camera = Image.Provider.Camera.create()
local cameraModel = Image.Provider.Camera.getInitialCameraModel(camera)

-- Setup  view
local view2D = View.create('viewer2D')
local view3D = View.create('viewer3D')

-- Setup pixel value range
local decoration = View.ImageDecoration.create()
View.ImageDecoration.setRange(decoration, 0, 10000)

-- Setup the pointcloud converter
local pointCloudConverter = Image.PointCloudConverter.create(cameraModel)

local function main()
  -- Start the camera
  Image.Provider.Camera.start(camera)
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--@handleOnNewImage(image:Image, sensordata:SensorData)
local function handleOnNewImage(image)
  -- 2D view
  -- Add the image to the viewer and present
  View.addImage(view2D, image[1], decoration)
  View.present(view2D)

  -- 3D view
  -- convert the images to a pointcloud, first argument is the distance image, second one is the intensity image
  local convert = Image.PointCloudConverter.convert(pointCloudConverter, image[1], image[2])
  -- Add the point cloud to the viewer and present
  View.addPointCloud(view3D, convert)
  View.present(view3D)
end
-- Registration of the 'handleOnNewImage' function to the cameras "OnNewImage" event
Image.Provider.Camera.register(camera, 'OnNewImage', handleOnNewImage)
