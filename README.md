# CubeIn3DWithCoreAnimation

A demo of 3D cube done purely in Core Animation

It uses  [AllApples](https://github.com/mihaelamj/allapples) Swift package, to enable the example to work both on *iOS* devices and on the *Mac*.

Well, that din't work out great, for I still have to make the Mac version to work correctly.

So on `iOS` and `iPadOS` it works as expected:

![Cube 3D](../main/Cube3DCA/DemoImages/cube_iOS_3D_.png)

This is cube assembled.

There's also a flattened version:

![Cube Flattened](../main/Cube3DCA/DemoImages/cube_iOS_flat_1.png)

The side number two is actually behin the side number 4.:

![Cube Flattened](../main/Cube3DCA/DemoImages/cube_iOS_flat_2.png)

As you can see here:

![Cube 3D Animating](../main/Cube3DCA/DemoImages/CoreAnimation_3D_Cube.gif)

The `macOS` version does not work yet.
I guess the `sublayerTransform` property is not working, and the transforms don't look the same.

The flattened version does not respect anchor points and positions.

![Cube Flattened](../main/Cube3DCA/DemoImages/cube_macOS_flat_messed_up.png)

The 3D version is transformed incorrectly.

![Cube Flattened](../main/Cube3DCA/DemoImages/cube_macOS_3D_messed_up.png)

Forks and PRs are more than welcome!!

[Here's the link to YouTube]( https://www.youtube.com/watch?v=exIGbi36_bk)
