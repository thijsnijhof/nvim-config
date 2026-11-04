-- Machine-local file: edit freely; deployment never overwrites an existing copy.
return {
    ai = { default = 'kiro' },
    acp = { provider = 'kiro-acp' },
    -- Override commands as needed, e.g.:
    -- godot = { command = '/path/to/Godot' },
    -- formatting = { gdformat = '/path/to/gdformat' },
    -- ai = { default = 'custom', agents = { custom = { '/path/to/agent', '--interactive' } } },
    -- acp = { provider = 'custom-acp', providers = {
    --     ['custom-acp'] = { name = 'Custom', command = '/path/to/agent', args = { '--acp' } },
    -- } },
}
