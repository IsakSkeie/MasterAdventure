using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Control_System
{
    internal class Lowpass
    {
        double a;
        double lastY = 0;
        
        public void Create(double filterconstant, double samplingTime)
        {
            a = samplingTime / (filterconstant + samplingTime);
        }

        public double filtrate(double u)
        {
            double y = (1 - a) * lastY + a * u;
            lastY = y;
            return y;
        }
    }
}
