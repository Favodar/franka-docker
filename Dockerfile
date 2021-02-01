FROM ros:melodic-ros-base

# GAZEBO

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2486D2DD83DB69272AFE98867170598AF249743

# setup sources.lists
RUN . /etc/os-release \
    && echo "deb http://packages.osrfoundation.org/gazebo/$ID-stable `lsb_release -sc` main" > /etc/apt/sources.list.d/gazebo-latest.list

# install gazebo packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    gazebo9=9.16.0-1* \
    && rm -rf /var/lib/apt/lists/*

# confirm installation
RUN which gzserver


# Install Gazebo Ros Packages from Source
# See: http://gazebosim.org/tutorials?tut=ros_installing&cat=connect_ros
RUN mkdir -p ~/catkin_ws/src \
    cd ~/catkin_ws/src \
    catkin_init_workspace \
    cd ~/catkin_ws \
    catkin_make

ENV . ~/catkin_ws/devel/setup.bash

# then download gazebo_ros_pkgs-melodic-devel, franka_gazebo-master, ros_controllers-melodic-devel
RUN cd ~/catkin_ws/src \
    git clone https://github.com/ros-simulation/gazebo_ros_pkgs.git -b melodic-devel \
    git clone https://github.com/ros-controls/ros_controllers.git -b melodic-devel \
    git clone https://github.com/frankaemika/libfranka.git \
    git clone https://github.com/mkrizmancic/franka_gazebo

RUN rosdep update \
    rosdep check --from-paths . --ignore-src --rosdistro melodic \
    rosdep install --from-paths . --ignore-src --rosdistro melodic -y