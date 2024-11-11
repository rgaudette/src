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
#ifndef __NOMAD400_SGTELIB_MODEL_MEGAITERATION__
#define __NOMAD400_SGTELIB_MODEL_MEGAITERATION__

// Manager for SgtelibModel iterations.
// Steps:
// - Generate points, using sgte model
// - Evaluate points
// - Post-processing

#include "../../Algos/IterationUtils.hpp"
#include "../../Algos/MegaIteration.hpp"

#include "../../nomad_nsbegin.hpp"

/// class SgtelibModelMegaIteration (Step)
class SgtelibModelMegaIteration: public MegaIteration, public IterationUtils
{
public:
    /// Constructor
    /**
     \param parentStep      The parent step of this step -- \b IN.
     \param k               The main iteration counter -- \b IN.
     \param barrier         The barrier for constraints handling -- \b IN.
     \param success         Success type of the previous MegaIteration. -- \b IN.
     */
    explicit SgtelibModelMegaIteration(const Step* parentStep,
                              size_t k,
                              std::shared_ptr<Barrier> barrier,
                              SuccessType success)
      : MegaIteration(parentStep, k, barrier, success),
        IterationUtils(parentStep)
    {
        init();
    }

    virtual ~SgtelibModelMegaIteration();

    /// Generate new points to evaluate
    void generateTrialPoints() override;

    void read(std::istream& is) override;
    void display(std::ostream& os) const override ;
    
private:
    void init();

    virtual void startImp() override ;
    virtual bool runImp() override;
    virtual void endImp() override;
    
    // Helper for generateTrialPoints()
    void generateIterations();
    void runIterationsAndSetTrialPoints();
    void filterCache();

};

/** Display useful values so that a new MegaIteration could be constructed using these values.
 */
std::ostream& operator<<(std::ostream& os, const SgtelibModelMegaIteration& megaIteration);

/// Get an MegaIteration values from a stream
std::istream& operator>>(std::istream& is, SgtelibModelMegaIteration& megaIteration);

#include "../../nomad_nsend.hpp"

#endif // __NOMAD400_SGTELIB_MODEL_MEGAITERATION__
