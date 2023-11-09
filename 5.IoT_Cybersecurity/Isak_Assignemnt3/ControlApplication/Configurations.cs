public class GlobalSettings
{
    private static GlobalSettings _instance;
    private static object _lock = new object();

    // Private constructor to prevent direct instantiation
    private GlobalSettings()
    {
        // Initialize your variables here
        SimulationName = "Default Simulation";
        SimulationDuration = 10;
    }

    public static GlobalSettings Instance
    {
        get
        {
            if (_instance == null)
            {
                lock (_lock)
                {
                    if (_instance == null)
                    {
                        _instance = new GlobalSettings();
                    }
                }
            }
            return _instance;
        }
    }

    // Define your globally accessible variables as public properties
    public string SimulationName { get; set; }
    public int SimulationDuration { get; set; }
}
