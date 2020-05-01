#ifndef TAGDATA_H
#define TAGDATA_H


class tagData
{
public:
    tagData();
    tagData(int id, bool available, double norm, double x, double y, double z, double yaw, double pitch, double roll);

private:

    int     m_tagID;
    bool    m_available;
    double  m_norm;
    double  m_x;
    double  m_y;
    double  m_z;
    double  m_angle1;
    double  m_angle2;
    double  m_angle3;



public:

    int     getTagID();
    bool    isAvailable();
    double  getNorm();
    double  getX();
    double  getY();
    double  getZ();
    double  getAngle1();
    double  getAngle2();
    double  getAngle3();


    void    setTagID(int value);
    void    setIsAvailable(bool status);
    void    setNorm(double value);
    void    setX(double value);
    void    setY(double value);
    void    setZ(double value);
    void    setAngle1(double value);
    void    setAngle2(double value);
    void    setAngle3(double value);

};

#endif // TAGDATA_H
