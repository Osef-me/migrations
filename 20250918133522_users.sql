-- Migration: Create users-related tables
-- Created: 2025-08-26
-- Author: Osef
-- Description: Schema for managing users, devices, bans, and pending registrations
-- Version: 1.0.0

-- ========================================
-- Table: users
-- Stores registered users
-- ========================================
CREATE TABLE users (
    discord_id BIGINT PRIMARY KEY,
    username TEXT,                            -- Optional, for display purposes
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    roles JSONB DEFAULT '["user"]'::jsonb NOT NULL
);

-- ========================================
-- Table: device_tokens
-- Stores tokens tied to user devices
-- ========================================
CREATE TABLE device_tokens (
    token UUID PRIMARY KEY,
    discord_id BIGINT REFERENCES users(discord_id) ON DELETE CASCADE,
    device_name TEXT,                         -- Optional, device identifier
    hwid TEXT,                                -- Optional, hardware identifier
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
);

-- ========================================
-- Table: bans
-- Stores user ban history
-- ========================================
CREATE TABLE bans (
    id SERIAL PRIMARY KEY,
    discord_id BIGINT REFERENCES users(discord_id) ON DELETE CASCADE,
    reason TEXT,                              -- Optional ban reason
    banned_at TIMESTAMP DEFAULT NOW() NOT NULL
);

-- ========================================
-- Table: new_users
-- Temporary table for unvalidated users
-- Prevents multiple accounts before validation
-- ========================================
CREATE TABLE new_users (
    discord_id BIGINT PRIMARY KEY,
    username TEXT,
    token UUID UNIQUE NOT NULL,               -- Validation token sent via Discord DM
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
);
