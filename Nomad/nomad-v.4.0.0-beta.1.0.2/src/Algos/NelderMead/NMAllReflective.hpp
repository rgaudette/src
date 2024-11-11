/*---------------------------------------------------------------------------------*/
/*  NOMAD - Nonlinear Optimization by Mesh Adaptive Direct Search -                */
/*                                                                                 */
/*  NOMAD - Version 4.0.0 has been created by                                      */
/*                 Viviane Rochon Montplaisir  - Polytechnique Montreal            */
/*                 Christophe Tribes           - Polytechnique Montreal            */
/*                                                                                 */
/*  The copyright of NOMAD - version 4.0.0 is owned by                             */
/*                 Sebastien Le Digabel        - Polytechnique Montreal            */
/*                 Viviane Rochon Montplaisir  - Polytechnique Montreal            */
/*                 Christophe Tribes           - Polytechnique Montreal            */
/*                                                                                 */
/*  NOMAD v4 has been funded by Rio Tinto, Hydro-Québec, NSERC (Natural Science    */
/*  and Engineering Research Council of Canada), INOVEE (Innovation en Energie     */
/*  Electrique and IVADO (The Institute for Data Valorization)                     */
/*                                                                                 */
/*  NOMAD v3 was created and developed by Charles Audet, Sebastien Le Digabel,     */
/*  Christophe Tribes and Viviane Rochon Montplaisir and was funded by AFOSR       */
/*  and Exxon Mobil.                                                               */
/*                                                                                 */
/*  NOMAD v1 and v2 were created and developed by Mark Abramson, Charles Audet,    */
/*  Gilles Couture, and John E. Dennis Jr., and were funded by AFOSR and           */
/*  Exxon Mobil.                                                                   */
/*                                                                                 */
/*  Contact information:                                                           */
/*    Polytechnique Montreal - GERAD                                               */
/*    C.P. 6079, Succ. Centre-ville, Montreal (Quebec) H3C 3A7 Canada              */
/*    e-mail: nomad@gerad.ca                                                       */
/*    phone : 1-514-340-6053 #6928                                                 */
/*    fax   : 1-514-340-5665                                                       */
/*                                                                                 */
/*  This program is free software: you can redistribute it and/or modify it        */
/*  under the terms of the GNU Lesser General Public License as published by       */
/*  the Free Software Foundation, either version 3 of the License, or (at your     */
/*  option) any later version.                                                     */
/*                                                                                 */
/*  This program is distributed in the hope that it will be useful, but WITHOUT    */
/*  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or          */
/*  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License    */
/*  for more details.                                                              */
/*                                                                                 */
/*  You should have received a copy of the GNU Lesser General Public License       */
/*  along with this program. If not, see <http://www.gnu.org/licenses/>.           */
/*                                                                                 */
/*  You can find information on the NOMAD software at www.gerad.ca/nomad           */
/*---------------------------------------------------------------------------------*/
#ifndef __NOMAD400_NMALLREFLECTIVE__
#define __NOMAD400_NMALLREFLECTIVE__

#include "../../Algos/NelderMead/NMMegaIteration.hpp"
#include "../../Algos/NelderMead/NMIterationUtils.hpp"
#include "../../Algos/Mads/MadsIteration.hpp"

#include "../../nomad_nsbegin.hpp"

/**
 Class to generate points for single pass NM on all reflective steps (REFLECT, EXPAND, INSIDE_CONTRACTION and OUTSIDE_CONTRACTION).
 The NMAllReflective::startImp function manages the creation process. The initial simplex is created by calling NMIteration::startImp(). The points are projected on mesh and updated with the information of the creating frame center.
 */
class NMAllReflective: public NMIteration, public NMIterationUtils
{
public:
    /// Constructor
    /**
     \param parentStep      The parent step of this step -- \b IN.
     \param frameCenter     The MADS frame center is used as simplex "center"  -- \b IN.
     \param madsMesh        Mads Mesh for trial point projection (can be null) -- \b IN.
     */
    explicit NMAllReflective(const Step* parentStep,
                             const std::shared_ptr<EvalPoint>& frameCenter,
                             const std::shared_ptr<NOMAD::MeshBase>& madsMesh)
      : NMIteration(parentStep, frameCenter, 0, madsMesh),
        NMIterationUtils(parentStep)
    {
        _stopReasons = std::make_shared<AlgoStopReasons<NMStopType>>();
    }
    // No Destructor needed - keep defaults.

    
private:
    
    /// Implementation of start tasks.
    /**
     - call the default Iteration::startImp
     - create the initial simplex if it is empty.
     - call NMAllReflective::generateTrialPoints
     - verify that trial points are on mesh.
     - update points with frame center.
     */
    void startImp() override ;
    
    /// Implementation of run task. Nothing to do.
    bool runImp() override { return  false;}
    
    /// Implementation of run task. Nothing to do.
    void endImp() override {}
    
    void generateTrialPoints() override;

};


#include "../../nomad_nsend.hpp"

#endif // __NOMAD400_NMALLREFLECTIVE__
