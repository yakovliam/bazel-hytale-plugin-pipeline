package org.example.myplugin;

import com.hypixel.hytale.server.core.plugin.JavaPlugin;
import com.hypixel.hytale.server.core.plugin.JavaPluginInit;
import org.checkerframework.checker.nullness.compatqual.NonNullDecl;
import org.example.common.api.util.KeyUtil;
import org.example.myplugin.command.ExampleCommand;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Main class for the MyPlugin plugin.
 */
public class MyPlugin extends JavaPlugin {
    private static final Logger LOGGER = LoggerFactory.getLogger(MyPlugin.class);

    /**
     * Constructor for MyPlugin.
     *
     * @param init The JavaPluginInit instance.
     */
    public MyPlugin(@NonNullDecl JavaPluginInit init) {
        super(init);
    }

    @Override
    protected void setup() {
        super.setup();

        String randomKey = KeyUtil.generateRandomKey();
        LOGGER.info("Generated random key: {}", randomKey);

        this.getCommandRegistry().registerCommand(new ExampleCommand());
    }
}
