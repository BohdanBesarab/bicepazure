Configuration install_iis{

    Import-DscResource -ModuleName PsDesiredStateConfiguration

    Node 'localhost'{
        WindowsFeature WebServer{
            Ensure = "Present"
            Name = "Web-Server"
        }
    }
}