package no.runsafe.plugin_name;

import no.runsafe.framework.RunsafePlugin;
import no.runsafe.framework.api.log.IDebug;

public class Plugin extends RunsafePlugin
{
	public static IDebug Debugger = null;

	@Override
	protected void PluginSetup()
	{
		Debugger = getComponent(IDebug.class);
		//addComponent(SomeComponent.class);
	}
}
