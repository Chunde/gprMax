cimport numpy as np

from gprMax.constants cimport floattype_t

cpdef void define_fine_geometry(
                    int nx,
                    int ny,
                    int nz,
                    int xs,
                    int xf,
                    int ys,
                    int yf,
                    int zs,
                    int zf,
                    float dx,
                    float dy,
                    float dz,
                    np.uint32_t[:, :, :, :] ID,
                    floattype_t[:, :] points,
                    np.uint32_t[:, :] x_lines,
                    np.uint32_t[:] x_materials,
                    np.uint32_t[:, :] y_lines,
                    np.uint32_t[:] y_materials,
                    np.uint32_t[:, :] z_lines,
                    np.uint32_t[:] z_materials
            ):
    
    cdef Py_ssize_t i, j, k
    cdef Py_ssize_t label = 0
    cdef Py_ssize_t counter_x = 0
    cdef Py_ssize_t counter_y = 0
    cdef Py_ssize_t counter_z = 0

    cdef int label_x, label_y, label_z

    for i in range(xs, xf + 1):
        for j in range(ys, yf + 1):
            for k in range(zs, zf + 1):
                points[label][0] = i * dx
                points[label][1] = j * dy
                points[label][2] = k * dz
                if i < xf:
                    # x connectivity
                    label_x = label + (ny + 1) * (nz + 1)
                    x_lines[counter_x][0] = label
                    x_lines[counter_x][1] = label_x
                    # material for the line
                    x_materials[counter_x] = ID[0, i, j, k]
                    counter_x += 1
                if j < yf:
                    label_y = label + nz + 1
                    y_lines[counter_y][0] = label
                    y_lines[counter_y][1] = label_y
                    y_materials[counter_y] = ID[1, i, j, k]
                    counter_y += 1
                if k < zf:
                    label_z = label + 1
                    z_lines[counter_z][0] = label
                    z_lines[counter_z][1] = label_z
                    z_materials[counter_z] = ID[2, i, j, k]
                    counter_z += 1

                label = label + 1
