using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Control_System
{
    class PID
    {
        double P = 0;
        double I = 0;
        public double ClaculateU(float Kp, float It, double temp, float SP, double Ts)
        {
            double Error = SP - temp;

            P = Kp * Error;
            I = ((Kp / It) * Error * Ts) + I;

            //Anti windup
            if (I > 5) I = 5;
            else if (I < -5) I = 0;

            double u = P + I;

            if (u > 5) u = 5;
            if (u < 0) u = 0; 

            return u;
        }

    }
}
