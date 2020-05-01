#include "tagdata.h"

tagData::tagData()
{
    m_tagID = -1;
    m_available = false;
    m_norm = -1;
    m_x = -1;
    m_y = -1;
    m_z = -1;
    m_angle1 = -1;
    m_angle2 = -1;
    m_angle3 = -1;
}



tagData::tagData(int id, bool available,  double norm, double x, double y, double z, double angle1, double angle2, double angle3)
{
    m_tagID = id;
    m_available = available;
    m_norm = norm;
    m_x = x;
    m_y = y;
    m_z = z;
    m_angle1 = angle1;
    m_angle2 = angle2;
    m_angle3 = angle3;
}




int tagData::getTagID()
{
    return m_tagID;
}



bool tagData::isAvailable()
{
    return m_available;
}




double tagData::getNorm()
{
    return m_norm;
}



double tagData::getX()
{
    return m_x;
}



double tagData::getY()
{
    return m_y;
}




double tagData::getZ()
{
    return m_z;
}



double tagData::getAngle1()
{
    return m_angle1;
}



double tagData::getAngle2()
{
    return m_angle2;
}



double tagData::getAngle3()
{
    return m_angle3;
}



void tagData::setTagID(int value)
{
    m_tagID = value;
}



void tagData::setIsAvailable(bool status)
{
    m_available = status;
}



void tagData::setNorm(double value)
{
    m_norm = value;
}



void tagData::setX(double value)
{
    m_x = value;
}



void tagData::setY(double value)
{
    m_y = value;
}


void tagData::setZ(double value)
{
    m_z = value;
}



void tagData::setAngle1(double value)
{
    m_angle1 = value;
}



void tagData::setAngle2(double value)
{
    m_angle2 = value;
}



void tagData::setAngle3(double value)
{
    m_angle3 = value;
}

