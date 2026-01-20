package com.example.exampleplugin;

import com.hypixel.hytale.server.core.plugin.JavaPlugin;
import com.hypixel.hytale.server.core.plugin.JavaPluginInit;

import javax.annotation.Nonnull;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ExamplePlugin extends JavaPlugin {
    private static final Logger LOGGER = LoggerFactory.getLogger(ExamplePlugin.class);

    /**
     * Constructor for ExamplePlugin.
     *
     * @param init The JavaPluginInit instance.
     */
    public ExamplePlugin(@Nonnull JavaPluginInit init) {
        super(init);
    }

    @Override
    protected void setup() {
        LOGGER.info("Registering ExamplePlugin!");
    }

    @Override
    public void start() {
        LOGGER.info("Starting ExamplePlugin!");
    }
}
