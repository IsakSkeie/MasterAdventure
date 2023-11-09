using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ControlApplication.Pages
{
    public class SimulationModel : PageModel
    {
        private readonly ILogger<PrivacyModel> _logger;

        [BindProperty]
        public string SimulationName { get; set; }

        [BindProperty]
        public int SimulationDuration { get; set; }


       

        public void OnGet()
        {

            SimulationName = GlobalSettings.Instance.SimulationName;
            SimulationDuration = GlobalSettings.Instance.SimulationDuration;
        }

        public SimulationModel(ILogger<PrivacyModel> logger)
        {
            _logger = logger;
            //SimulationName = "Default Simulation Name";
            //SimulationDuration = 99; // Default duration in minutes
        }

        public IActionResult OnPost()
        {
            // This method handles the form submission
            if (!ModelState.IsValid)
            {
                return Page();
            }

            // Save the settings to a configuration file, database, or another storage mechanism
            // You can use SimulationName and SimulationDuration properties here

            // Optionally, you can display a confirmation message
            TempData["Message"] = "Settings saved successfully!";
            GlobalSettings.Instance.SimulationName = SimulationName;
            GlobalSettings.Instance.SimulationDuration = SimulationDuration;

            return RedirectToPage("Simulation"); // Redirect to the same page after submission
        }
    }
}