using System.ComponentModel.DataAnnotations;

namespace DataMonitor
{
    public class TemperatureData
    {

        [Key] // Specify the primary key
        public int Id { get; set; }
        public DateTime TimeStamp { get; set; }
        public float PV { get; set; }
        public float SP { get; set; }
    }
}
