using Microsoft.EntityFrameworkCore;

namespace DataMonitor
{
    public class AppDBContext : DbContext
    {

        public IConfiguration _config { get; set; }

        public AppDBContext(IConfiguration config)
        {
            _config = config;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(_config.GetConnectionString("DatabaseConnection"));
        }

        public DbSet<TemperatureData> Temperatures { get; set; } 
    }
}
