%STRIPRES       Strip the results from a PMI data structure.

function ds = stripres(ds)

if isfield(ds, 'Fwd')
    if isfield(ds.Fwd, 'A');
        ds.Fwd.A = [];
    end
    if isfield(ds.Fwd, 'PhiInc')
        ds.Fwd.PhiInc = [];
    end
    if isfield(ds.Fwd, 'PhiScat')
        ds.Fwd.PhiScat = [];
    end
end

if isfield(ds, 'PhiTotal')
    ds.PhiTotal = [];
end

if isfield(ds, 'PhiTotalN')
    ds.PhiTotalN = [];
end

if isfield(ds, 'PhiTotalNw')
    ds.PhiTotalNw = [];
end

if isfield(ds, 'Inv')
    if isfield(ds.Inv, 'A');
        ds.Inv.A = [];
    end
    if isfield(ds.Inv, 'Aw');
        ds.Inv.Aw = [];
    end
    if isfield(ds.Inv, 'PhiInc')
        ds.Inv.PhiInc = [];
    end
end

if isfield(ds, 'Noise')
    if isfield(ds.Noise, 'w');
        ds.Noise.w = [];
    end
end
